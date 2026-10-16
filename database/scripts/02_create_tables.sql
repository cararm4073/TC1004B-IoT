-- ============================================
-- xHome - 02_create_tables.sql
-- Creates the tables (parents first, children after)
-- ============================================

USE xhome;

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
	arduino_pin VARCHAR(10),              -- NULL for I2C devices
	FOREIGN KEY (room_id) REFERENCES Room(room_id),
	FOREIGN KEY (type_id) REFERENCES Device_type(type_id)
);

CREATE TABLE Measurements (
	measurement_id INT AUTO_INCREMENT PRIMARY KEY,
	device_id INT NOT NULL,
	value DECIMAL(10,2) NOT NULL,
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (device_id) REFERENCES Device(device_id)
);

CREATE TABLE Events_actuators (
	event_id INT AUTO_INCREMENT PRIMARY KEY,
	device_id INT NOT NULL,
	user_id INT,                          -- NULL when the event is automatic
	action VARCHAR(50) NOT NULL,
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (device_id) REFERENCES Device(device_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

