use teloxide::prelude::*;
use diesel::prelude::*;
use teloxide::types::{MediaKind, MessageCommon, MessageKind, User};
use crate::DbConnection;

pub async fn run_tg_bot(db: DbConnection) {
    pretty_env_logger::init();

    let bot = Bot::from_env();

    Dispatcher::builder(bot,
                        Update::filter_message()
                            .branch(
                                dptree::filter(|msg: Message| matches!(msg.kind, MessageKind::Common(_)))
                                    .endpoint(|msg: Message, bot: Bot, db: DbConnection| async move {
                                        handle_message(bot, msg, db).await
                                    }
                                    )
                            ),
    )
        .dependencies(dptree::deps![db])
        .enable_ctrlc_handler()
        .build()
        .dispatch()
        .await;
}

async fn handle_message(bot: Bot, msg: Message, db: DbConnection) -> ResponseResult<()> {
    if let Message {
        kind: MessageKind::Common(MessageCommon { from, media_kind: MediaKind::Text(text), .. }),
        chat,
        ..
    } = &msg {
        let admin = matches!(from, Some(User {id : UserId(429171352), ..}));

        if admin { return admin_way(bot, msg, db).await; }
        let chat_id = chat.id;
        if text.text.starts_with("/start") {
            bot.send_message(chat_id, "Hello!").await?;
        } else {
            bot.send_message(chat_id, format!("{:?}", from)).await?;
        }
    }


    Ok(())
}

fn get_names(db: DbConnection) -> Vec<String> {
    use crate::schema::s_transactions::dsl::*;
    let mut conn = db.lock().unwrap();

    let results = s_transactions.select(name)
        .group_by(name)
        .load::<String>(&mut *conn)
        .expect("Error loading posts");

    results
}

fn add_transaction(db: DbConnection, name: String, amount: f64) -> Result<(), String> {
    use crate::schema::s_transactions::dsl::s_transactions;
    let mut conn = db.lock().unwrap();

    let value = Transaction {
        name,
        amount,
    };

    diesel::insert_into(s_transactions)
        .values(&value)
        .execute(&mut *conn)
        .map(|_| ())
        .map_err(|e| format!("{:?}", e))
}

async fn admin_way(bot: Bot, msg: Message, db: DbConnection) -> ResponseResult<()> {
    if let Message {
        kind: MessageKind::Common(MessageCommon { from, media_kind: MediaKind::Text(text), .. }),
        chat,
        ..
    } = msg {
        let chat_id = chat.id;
        let text = text.text;
        if text.starts_with("/start") {
            bot.send_message(chat_id, "Hello!").await?;
        } else if text.starts_with("/names") {
            let names = get_names(db);
            bot.send_message(chat_id, format!("{:?}", names.join("\n"))).await?;
        } else if text.starts_with("/add") {
            let content = &text[4..];
            let idx = content.rfind(' ');
            if idx.is_none() {
                bot.send_message(chat_id, "Wrong format").await?;
                return Ok(());
            }
            let (name, amount) = content.split_at(idx.unwrap());


            let amount = amount.trim().parse::<f64>();
            if amount.is_err() {
                bot.send_message(chat_id, "Wrong format").await?;
                return Ok(());
            }
            let amount = amount.unwrap();
            match add_transaction(db, name.trim().to_string(), amount) {
                Ok(_) => {
                    bot.send_message(chat_id, "Added").await?;
                }
                Err(e) => {
                    bot.send_message(chat_id, format!("Error: {}", e)).await?;
                }
            }
        } else {
            bot.send_message(chat_id, format!("{:?}", from)).await?;
        }
    }

    Ok(())
}

#[derive(Insertable)]
#[diesel(table_name = crate::schema::s_transactions)]
struct Transaction {
    name: String,
    amount: f64,
}