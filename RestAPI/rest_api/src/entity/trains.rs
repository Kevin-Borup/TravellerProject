//! `SeaORM` Entity. Generated by sea-orm-codegen 0.12.2

use sea_orm::entity::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, PartialEq, DeriveEntityModel, Eq, Serialize, Deserialize)]
#[sea_orm(table_name = "trains")]
pub struct Model {
    #[sea_orm(primary_key, auto_increment = false)]
    pub id: Uuid,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {
    #[sea_orm(has_many = "super::assigned_staff::Entity")]
    AssignedStaff,
    #[sea_orm(has_many = "super::routes::Entity")]
    Routes,
    #[sea_orm(has_many = "super::seat::Entity")]
    Seat,
}

impl Related<super::assigned_staff::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::AssignedStaff.def()
    }
}

impl Related<super::routes::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::Routes.def()
    }
}

impl Related<super::seat::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::Seat.def()
    }
}

impl Related<super::staff::Entity> for Entity {
    fn to() -> RelationDef {
        super::assigned_staff::Relation::Staff.def()
    }
    fn via() -> Option<RelationDef> {
        Some(super::assigned_staff::Relation::Trains.def().rev())
    }
}

impl Related<super::ticket::Entity> for Entity {
    fn to() -> RelationDef {
        super::seat::Relation::Ticket.def()
    }
    fn via() -> Option<RelationDef> {
        Some(super::seat::Relation::Trains.def().rev())
    }
}

impl ActiveModelBehavior for ActiveModel {}
