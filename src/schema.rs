// @generated automatically by Diesel CLI.

diesel::table! {
    s_names (name) {
        name -> Text,
    }
}

diesel::table! {
    s_transactions (id) {
        name -> Text,
        amount -> Float8,
        id -> Int4,
    }
}

diesel::joinable!(s_transactions -> s_names (name));

diesel::allow_tables_to_appear_in_same_query!(
    s_names,
    s_transactions,
);
