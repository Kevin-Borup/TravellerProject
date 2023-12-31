CREATE EXTENSION IF NOT EXISTS "UUID-ossp";

CREATE TABLE person(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE staff(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    person_id UUID,
    CONSTRAINT fk_person_id
        FOREIGN KEY(person_id) 
            REFERENCES person(id)    
);

CREATE TABLE passenger(
    id UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    person_id UUID NOT NULL,
    CONSTRAINT fk_person_id
        FOREIGN KEY(person_id) 
            REFERENCES person(id)
);

CREATE TABLE train(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
);

CREATE TABLE seat(
    id SERIAL NOT NULL,
    train_id UUID NOT NULL,
    reserved BOOL NOT NULL,
    CONSTRAINT pk_seat 
		PRIMARY KEY (id, train_id),
    CONSTRAINT fk_seat_train_id 
		FOREIGN KEY (train_id) 
			REFERENCES train(id)
);

CREATE TABLE ticket (
    passenger_id UUID,
    seat_id SERIAL,
    train_id UUID,
     CONSTRAINT pk_ticket 
        PRIMARY KEY (passenger_id, seat_id, train_id),
    CONSTRAINT fk_ticket_passenger 
        FOREIGN KEY (passenger_id)
            REFERENCES passenger("id"),
    CONSTRAINT fk_ticket_seat FOREIGN KEY (seat_id, train_id) 
        REFERENCES seat("id", train_id)
);

CREATE TABLE station (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    platforms int NOT NULL
);

CREATE TABLE roadmap (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    origin_id UUID NOT NULL,
    destination_id UUID NOT NULL,
    estimated_time integer NOT NULL,
	CONSTRAINT fk_origin_station_id
        FOREIGN KEY (origin_id)
            REFERENCES station(id),
    CONSTRAINT fk_destination_station_id
        FOREIGN KEY (destination_id) 
            REFERENCES station(id)
);

CREATE TABLE destination (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    departure timestamp  NOT NULL,
    arrival timestamp  NOT NULL,
    roadmap_id UUID NOT NULL,
    CONSTRAINT fk_roadmap_id 
        FOREIGN KEY (roadmap_id) 
            REFERENCES roadmap(id)
);

CREATE TABLE route (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    train_id UUID NOT NULL,
    CONSTRAINT fk_train_id
        FOREIGN KEY (train_id) 
            REFERENCES train(id)
);

CREATE TABLE route_destination(
    route_id UUID NOT NULL,
    destination_id UUID NOT NULL,
	destination_order real NOT NULL,
    CONSTRAINT pk_route_destination 
		PRIMARY KEY (route_id, destination_id),
    CONSTRAINT fk_route_destination_route 
		FOREIGN KEY (route_id) 
			REFERENCES route(id),
    CONSTRAINT fk_route_destination_destination 
		FOREIGN KEY (destination_id) 
			REFERENCES destination(id)
);

CREATE TABLE assigned_staff (
    train_id UUID NOT NULL,
    staff_id UUID NOT NULL,
    CONSTRAINT pk_assigned_staff 
		PRIMARY KEY (train_id, staff_id),
    CONSTRAINT fk_assigned_staff_train 
		FOREIGN KEY (train_id) 
			REFERENCES train(id),
    CONSTRAINT fk_assigned_staff_staff 
		FOREIGN KEY (staff_id) 
			REFERENCES staff(id)
);

-- DROP TABLE IF EXISTS assigned_staff, route_destination, route, destination, roadmap, station, ticket, seat, train, passenger, staff, person CASCADE;
-- DROP EXTENSION IF EXISTS "UUID-ossp";