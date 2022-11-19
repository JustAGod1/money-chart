use diesel::prelude::*;

#[derive(Queryable)]
pub struct Name {
    pub name: String
}

#[derive(Queryable)]
pub struct Transaction {
    pub name: String,
    pub amount: f64,
    pub id: i32
}
