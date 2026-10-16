-- Create the database on the current server
DROP DATABASE IF EXISTS xhome;

CREATE DATABASE xhome;

USE xhome;

-- Create the tables inside of the database, without adding foreign keys at once
CREATE TABLE Room (
	room_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	floor INT NOT NULL
);

CREATE TABLE Device_type (
	type_id INT AUTO_INCREMENT PRIMARY KEY,
	model VARCHAR(60) NOT NULL,
	category VARCHAR(20) NOT NULL,        -- sensor, actuator or logic
	measurement_units VARCHAR(20)
);

CREATE TABLE Users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	role VARCHAR(20) NOT NULL             -- admin or user
);

CREATE TABLE Device (
	device_id INT AUTO_INCREMENT PRIMARY KEY,
	room_id INT NOT NULL,
	type_id INT NOT NULL,
	name VARCHAR(60) NOT NULL,
	location VARCHAR(60),                 -- position inside the room
	arduino_pin VARCHAR(10)               -- NULL for I2C devices
);

CREATE TABLE Measurements (
	measurement_id INT AUTO_INCREMENT PRIMARY KEY,
	device_id INT NOT NULL,
	value DECIMAL(10,2) NOT NULL,
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Events_actuators (
	event_id INT AUTO_INCREMENT PRIMARY KEY,
	device_id INT NOT NULL,
	user_id INT,                          -- NULL when the event is automatic, no need for user
	action VARCHAR(50) NOT NULL,
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign keys
ALTER TABLE Device
	ADD CONSTRAINT fk_device_room
		FOREIGN KEY (room_id) REFERENCES Room(room_id),
	ADD CONSTRAINT fk_device_type
		FOREIGN KEY (type_id) REFERENCES Device_type(type_id);

ALTER TABLE Measurements
	ADD CONSTRAINT fk_measurements_device
		FOREIGN KEY (device_id) REFERENCES Device(device_id);

ALTER TABLE Events_actuators
	ADD CONSTRAINT fk_events_device
		FOREIGN KEY (device_id) REFERENCES Device(device_id),
	ADD CONSTRAINT fk_events_user
		FOREIGN KEY (user_id) REFERENCES Users(user_id);




-- Add rooms to the db
INSERT INTO Room (name, floor) VALUES
('Living room', 1),                                 -- ROOM 1
('Kitchen', 1),                                     -- ROOM 2
('Bedroom', 2),                                     -- ROOM 3
('Entrance', 1);                                    -- ROOM 4

-- Add devices from our kit, the room_id is taken from prev table, type_id ranging from 1 to 8 as for now they are different
INSERT INTO Device (room_id, type_id, name, location, arduino_pin) VALUES
(1, 1, 'BME280 Temperature', 'Wall', NULL),          -- I2C
(1, 2, 'BME280 Pressure', 'Wall', NULL),             -- I2C
(1, 3, 'LDR Light', 'Near window', 'A0'),
(4, 4, 'Rain Sensor', 'Roof', 'A1'),
(4, 5, 'Distance Sensor', 'Door', NULL),             -- I2C
(1, 6, 'OLED Display', 'Wall', NULL),                -- I2C
(4, 7, 'Buzzer', 'Door', 'D8'),
(4, 8, 'MG90S Servo', 'Window', 'D9');


-- Example of measurements, not real ones
INSERT INTO Measurements (device_id, value, timestamp) VALUES
(5, 143.00, '2026-10-16 08:41:50'),                 -- distance sensor
(2, 781.20, '2026-10-16 09:00:22'),                 -- pressure sensor
(1, 21.30, '2026-10-16 09:02:18'),                  -- BME280 Temp
(3, 590.00, '2026-10-16 09:30:57'),                 --Light sensor
(4, 380.00, '2026-10-16 10:15:20');                 -- rain sensor

-- Example of events from actuators
INSERT INTO Events_actuators (device_id, user_id, action, timestamp) VALUES
(7, NULL, 'ON', '2026-10-16 08:41:50'),
(6, NULL, 'DISPLAY_WELCOME', '2026-10-16 08:41:55'),
(8, 1, 'MOVE_TO_90', '2026-10-16 09:05:10'),
(6, NULL, 'DISPLAY_TEMP', '2026-10-16 09:40:22'),
(8, NULL, 'MOVE_TO_0', '2026-10-16 10:16:03'),
(7, 2, 'OFF', '2026-10-16 10:22:31');

