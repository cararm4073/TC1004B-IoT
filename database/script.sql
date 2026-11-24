-- Seed scirpt for creating the database

--in case the separate files were used, don't drop it again
DROP DATABASE IF EXISTS xhome;

CREATE DATABASE xhome;

USE xhome;

--create tables
CREATE TABLE Room (
	room_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	floor INT NOT NULL DEFAULT 1
);

CREATE TABLE Device_type (
	type_id INT AUTO_INCREMENT PRIMARY KEY,
	model VARCHAR(60) NOT NULL,
	category VARCHAR(20) NOT NULL,        -- sensor, actuator, access or logic
	measurement_units VARCHAR(20)
);

CREATE TABLE Users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	role VARCHAR(20) NOT NULL,            -- admin or user
	rfid_uid VARCHAR(32) UNIQUE NULL,
	is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Device (
	device_id INT AUTO_INCREMENT PRIMARY KEY,
	room_id INT NOT NULL,
	type_id INT NOT NULL,
	name VARCHAR(60) NOT NULL,
	location VARCHAR(60),                 -- position inside the room
	arduino_pin VARCHAR(30),              -- pin(s) or bus (I2C / SPI)
	is_controllable BOOLEAN NOT NULL DEFAULT FALSE,
	current_state VARCHAR(30) NULL
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
	user_id INT,                          -- NULL when the event is automatic
	action VARCHAR(50) NOT NULL,
	source VARCHAR(20) NOT NULL DEFAULT 'auto', -- dashboard, physical or auto
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Access_logs (
	log_id INT AUTO_INCREMENT PRIMARY KEY,
	device_id INT NOT NULL,
	user_id INT NULL,                     -- NULL when the RFID card is unknown
	rfid_uid VARCHAR(32) NOT NULL,
	access_granted BOOLEAN NOT NULL,
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

--add foreign keys
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

ALTER TABLE Access_logs
	ADD CONSTRAINT fk_access_device
		FOREIGN KEY (device_id) REFERENCES Device(device_id),
	ADD CONSTRAINT fk_access_user
		FOREIGN KEY (user_id) REFERENCES Users(user_id);

--insert data (rooms, devices, users), sample measurements
INSERT INTO Room (name, floor) VALUES
('Living room', 1),                   -- room_id 1
('Bathroom', 1),                      -- room_id 2
('Bedroom', 1),                       -- room_id 3
('Exterior', 1),                      -- room_id 4
('Garage', 1);                        -- room_id 5

INSERT INTO Device_type (model, category, measurement_units) VALUES
('BME280 (temperature)', 'sensor', 'C'),       -- type_id 1
('BME280 (humidity)', 'sensor', '%'),          -- type_id 2
('BME280 (pressure)', 'sensor', 'hPa'),        -- type_id 3
('LDR', 'sensor', 'ADC'),                      -- type_id 4
('Rain sensor', 'sensor', 'ADC'),              -- type_id 5
('VL53L0X', 'sensor', 'mm'),                   -- type_id 6
('Push button', 'sensor', 'state'),            -- type_id 7
('SSD1306 OLED', 'actuator', NULL),            -- type_id 8
('Buzzer', 'actuator', NULL),                  -- type_id 9
('Servo MG90S', 'actuator', NULL),             -- type_id 10
('LED', 'actuator', NULL),                     -- type_id 11
('MFRC522 RFID', 'access', NULL),              -- type_id 12
('74HC04 (NOT gate)', 'logic', NULL),          -- type_id 13
('74HC08 (AND gate)', 'logic', NULL);          -- type_id 14

INSERT INTO Users (name, role, rfid_uid, is_active) VALUES
('Admin', 'admin', 'A1B2C3D4', TRUE),
('Resident 1', 'user', 'E5F60718', TRUE),
('Carlos', 'admin', NULL, TRUE),
('Bernardo', 'user', NULL, TRUE),
('Pablo', 'user', NULL, TRUE);

--add devices to rooms
INSERT INTO Device (room_id, type_id, name, location, arduino_pin, is_controllable, current_state) VALUES
(1, 1,  'BME280 Temperature',    'Wall',                  'SDA/SCL',                  FALSE, NULL),     -- device_id 1
(1, 2,  'BME280 Humidity',       'Wall',                  'SDA/SCL',                  FALSE, NULL),     -- device_id 2
(1, 8,  'AMOLED / OLED Display', 'Wall',                  'SDA/SCL',                  TRUE,  'ON'),     -- device_id 3
(1, 7,  'Push Button',           'Control board',         'D4',                       FALSE, NULL),     -- device_id 4
(1, 13, '74HC04 (NOT gate)',     'Control board',         NULL,                       FALSE, NULL),     -- device_id 5
(1, 14, '74HC08 (AND gate)',     'Control board',         NULL,                       FALSE, NULL),     -- device_id 6
(3, 11, 'LED Bedroom (led1)',    'Ceiling',               'D6',                       TRUE,  'OFF'),    -- device_id 7
(2, 11, 'LED Bathroom (led2)',   'Ceiling',               'D7',                       TRUE,  'OFF'),    -- device_id 8
(5, 11, 'LED Garage (led3)',     'Ceiling',               'D8',                       TRUE,  'OFF'),    -- device_id 9
(5, 10, 'Servo MG90S',           'Garage door (pending)', 'D5',                       TRUE,  'CLOSED'), -- device_id 10
(4, 5,  'Rain Sensor',           'Roof',                  'A0 / D2',                  FALSE, NULL),     -- device_id 11
(4, 6,  'Distance Sensor',       'Entrance',              'SDA/SCL',                  FALSE, NULL),     -- device_id 12
(4, 12, 'RFID RC522',            'Entrance',              'RST:A2 SS:D10 SPI:D11-13', FALSE, NULL),     -- device_id 13
(4, 9,  'Buzzer',                'Entrance',              'D3',                       TRUE,  'OFF');    -- device_id 14

-- Sample measurements
INSERT INTO Measurements (device_id, value, timestamp) VALUES
(1,  22.40,  '2026-11-23 08:30:00'),
(2,  48.50,  '2026-11-23 08:30:00'),
(11, 380.00, '2026-11-23 08:31:10'),
(12, 143.00, '2026-11-23 08:31:15');

--actuator events
INSERT INTO Events_actuators (device_id, user_id, action, source, timestamp) VALUES
(14, NULL, 'ON',      'auto',      '2026-11-23 08:32:00'),
(7,  1,    'ON',      'dashboard', '2026-11-23 08:35:10'),
(8,  2,    'OFF',     'physical',  '2026-11-23 08:40:00'),
(10, 1,    'OPEN',    'dashboard', '2026-11-23 08:45:00');

--rfid access logs
INSERT INTO Access_logs (device_id, user_id, rfid_uid, access_granted, timestamp) VALUES
(13, 1,    'A1B2C3D4', TRUE,  '2026-11-23 08:32:00'),
(13, NULL, '99887766', FALSE, '2026-11-23 08:33:12');
