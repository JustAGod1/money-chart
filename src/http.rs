use std::str::FromStr;
use diesel::dsl::{sql};
use warp::{Filter};
use warp::reply::Json;
use crate::DbConnection;
use diesel::prelude::*;
use diesel::sql_types::Float8;
use serde::Serialize;

pub(crate) async fn serve_http(db: DbConnection) {

    let static_route = warp::get()
        .and(
            warp::fs::dir("static/dist")
                .or(warp::fs::dir("static/public"))
        );

    let api_route = warp::path("api");
    let data_route = warp::path("data")
        .map(move || {
            request_data(db.clone())
        });

    let server = warp::any().and(
        warp::get().and(
            static_route
        )
            .or(
                warp::post().and(
                    api_route
                        .and(data_route)
                )
            )
    );


    warp::serve(server)
        .tls()
        .run(([0,0,0,0], u16::from_str(&std::env::var("port").unwrap()).unwrap())).await;
}

fn request_data(db: DbConnection) -> Json {
    use crate::schema::s_transactions::dsl::*;
    let mut conn = db.lock().unwrap();

    let results = s_transactions.select((name, sql::<Float8>("sum(amount)")))
        .group_by(name)
        .load::<Transaction>(&mut *conn)
        .expect("Error loading posts");

    warp::reply::json(&results)
}

#[derive(Queryable)]
#[derive(Serialize)]
struct Transaction {
    name: String,
    amount: f64,
}