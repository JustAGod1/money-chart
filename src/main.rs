mod models;
mod schema;
mod http;
mod tg;

use std::env;
use std::sync::{Arc, Mutex};
use diesel::{Connection, PgConnection};
use dotenv::dotenv;
use warp::Filter;
use self::models::*;
use self::schema::*;
use diesel::prelude::*;
use futures::join;
use tracing::Level;
use tracing_subscriber::FmtSubscriber;


pub type DbConnection = Arc<Mutex<PgConnection>>;

#[tokio::main]
async fn main() {
    // a builder for `FmtSubscriber`.
    let subscriber = FmtSubscriber::builder()
        // all spans/events with a level higher than TRACE (e.g, debug, info, warn, etc.)
        // will be written to stdout.
        .with_max_level(Level::TRACE)
        // completes the builder.
        .finish();

    tracing::subscriber::set_global_default(subscriber)
        .expect("setting default subscriber failed");

    let db = open_db_connection();

    join!(http::serve_http(db.clone())/*,tg::run_tg_bot(db.clone())*/);

}

fn open_db_connection() -> DbConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let conn = PgConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url));

    return Arc::new(Mutex::new(conn));
}
