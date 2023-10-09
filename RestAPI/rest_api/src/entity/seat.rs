//! `SeaORM` Entity. Generated by sea-orm-codegen 0.12.2

use sea_orm::entity::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, PartialEq, DeriveEntityModel, Eq, Serialize, Deserialize)]
#[sea_orm(table_name = "seat")]
pub struct Model {
    #[sea_orm(primary_key)]
    pub id: i32,
    #[sea_orm(primary_key, auto_increment = false)]
    pub train_id: Uuid,
    pub reserved: bool,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {
    #[sea_orm(has_many = "super::ticket::Entity")]
    Ticket,
    #[sea_orm(
        belongs_to = "super::trains::Entity",
        from = "Column::TrainId",
        to = "super::trains::Column::Id",
        on_update = "NoAction",
        on_delete = "NoAction"
    )]
    Trains,
}

impl Related<super::ticket::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::Ticket.def()
    }
}

impl Related<super::trains::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::Trains.def()
    }
}

impl ActiveModelBehavior for ActiveModel {}