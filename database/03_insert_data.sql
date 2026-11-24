-- Sample data 

USE xhome;

INSERT INTO Room (name, floor) VALUES
('Living room', 1),
('Kitchen', 1),
('Bedroom', 2),
('Entrance', 1);

-- type_id 1 to 12 (in this order)
INSERT INTO Device_type (model, category, measurement_units) VALUES
('BME280 (temperature)', 'sensor', 'C'),
('BME280 (pressure)', 'sensor', 'hPa'),
('LDR', 'sensor', 'ADC'),
('Rain sensor', 'sensor', 'ADC'),
('VL53L0X', 'sensor', 'mm'),
('Push button', 'sensor', 'state'),
('SSD1306 OLED', 'actuator', NULL),
('Buzzer', 'actuator', NULL),
('Servo 360', 'actuator', NULL),
('LED', 'actuator', NULL),
('NE555 timer', 'logic', NULL),
('Logic gate', 'logic', NULL);

INSERT INTO Users (name, role) VALUES
('Admin', 'admin'),
('Resident 1', 'user');

-- device_id 1 to 12 (in this order)
INSERT INTO Device (room_id, type_id, name, location, arduino_pin) VALUES
(1, 1, 'BME280 Temperature', 'Wall', NULL),
(1, 2, 'BME280 Pressure', 'Wall', NULL),
(1, 3, 'LDR Light', 'Near window', 'A0'),
(4, 4, 'Rain Sensor', 'Roof', 'A1'),
(4, 5, 'Distance Sensor', 'Door', NULL),
(4, 6, 'Push Button', 'Door frame', 'D2'),
(1, 7, 'OLED Display', 'Wall', NULL),
(4, 8, 'Buzzer', 'Door', 'D8'),
(4, 9, 'Servo 360', 'Window', 'D9'),
(3, 10, 'Bedroom LED', 'Ceiling', 'D7'),
(1, 11, 'NE555 Timer', 'Control board', 'D4'),
(1, 12, 'Logic Gate', 'Control board', NULL);

INSERT INTO Measurements (device_id, value, timestamp) VALUES
(6, 1.00, '2026-10-16 08:41:49'),
(5, 143.00, '2026-10-16 08:41:50'),
(2, 781.20, '2026-10-16 09:00:22'),
(1, 21.30, '2026-10-16 09:02:18'),
(3, 590.00, '2026-10-16 09:30:57'),
(4, 380.00, '2026-10-16 10:15:20');

INSERT INTO Events_actuators (device_id, user_id, action, timestamp) VALUES
(8, NULL, 'ON', '2026-10-16 08:41:50'),
(7, NULL, 'DISPLAY_WELCOME', '2026-10-16 08:41:55'),
(9, 1, 'ROTATE_CW', '2026-10-16 09:05:10'),
(7, NULL, 'DISPLAY_TEMP', '2026-10-16 09:40:22'),
(9, NULL, 'ROTATE_CCW', '2026-10-16 10:16:03'),
(10, 2, 'ON', '2026-10-16 10:22:31');

-- Update rooms with current physical layout
UPDATE Room SET name = 'Living room', floor = 1 WHERE room_id = 1;
UPDATE Room SET name = 'Bathroom', floor = 1 WHERE room_id = 2;
UPDATE Room SET name = 'Bedroom', floor = 1 WHERE room_id = 3;
UPDATE Room SET name = 'Exterior', floor = 1 WHERE room_id = 4;
INSERT INTO Room (name, floor) VALUES ('Garage', 1);

--Add BME280 and RFID sensors. physical logic
INSERT INTO Device_type (model, category, measurement_units) VALUES
('BME280 (humidity)', 'sensor', '%'),
('MFRC522 RFID', 'access', NULL),
('74HC04 (NOT gate)', 'logic', NULL),
('74HC08 (AND gate)', 'logic', NULL);

--asign sample RFID's uid and add users
UPDATE Users SET rfid_uid = 'A1B2C3D4', is_active = TRUE WHERE user_id = 1;
UPDATE Users SET rfid_uid = 'E5F60718', is_active = TRUE WHERE user_id = 2;
INSERT INTO Users (name, role, rfid_uid, is_active) VALUES
('Carlos', 'admin', NULL, TRUE),
('Bernardo', 'user', NULL, TRUE),
('Pablo', 'user', NULL, TRUE);

--update existing devices to current pins and locations
UPDATE Device SET location = 'Wall', arduino_pin = 'SDA/SCL' WHERE device_id IN (1, 2);
UPDATE Device SET room_id = 4, location = 'Roof', arduino_pin = 'A0 / D2' WHERE device_id = 4;
UPDATE Device SET room_id = 4, location = 'Entrance', arduino_pin = 'SDA/SCL' WHERE device_id = 5;
UPDATE Device SET room_id = 1, location = 'Control board', arduino_pin = 'D4' WHERE device_id = 6;
UPDATE Device SET room_id = 1, name = 'AMOLED / OLED Display', arduino_pin = 'SDA/SCL', is_controllable = TRUE, current_state = 'ON' WHERE device_id = 7;
UPDATE Device SET room_id = 4, location = 'Entrance', arduino_pin = 'D3', is_controllable = TRUE, current_state = 'OFF' WHERE device_id = 8;
UPDATE Device SET room_id = (SELECT room_id FROM Room WHERE name = 'Garage' LIMIT 1), name = 'Servo MG90S', location = 'Garage door (pending)', arduino_pin = 'D5', is_controllable = TRUE, current_state = 'CLOSED' WHERE device_id = 9;
UPDATE Device SET room_id = 3, name = 'LED Bedroom (led1)', location = 'Ceiling', arduino_pin = 'D6', is_controllable = TRUE, current_state = 'OFF' WHERE device_id = 10;
UPDATE Device SET name = '74HC04 (NOT gate)', location = 'Control board' WHERE device_id = 12;

--add new devices
INSERT INTO Device (room_id, type_id, name, location, arduino_pin, is_controllable, current_state) VALUES
((SELECT room_id FROM Room WHERE name = 'Bathroom' LIMIT 1), (SELECT type_id FROM Device_type WHERE model = 'LED' LIMIT 1), 'LED Bathroom (led2)', 'Ceiling', 'D7', TRUE, 'OFF'),
((SELECT room_id FROM Room WHERE name = 'Garage' LIMIT 1), (SELECT type_id FROM Device_type WHERE model = 'LED' LIMIT 1), 'LED Garage (led3)', 'Ceiling', 'D8', TRUE, 'OFF'),
((SELECT room_id FROM Room WHERE name = 'Living room' LIMIT 1), (SELECT type_id FROM Device_type WHERE model = 'BME280 (humidity)' LIMIT 1), 'BME280 Humidity', 'Wall', 'SDA/SCL', FALSE, NULL),
((SELECT room_id FROM Room WHERE name = 'Exterior' LIMIT 1), (SELECT type_id FROM Device_type WHERE model = 'MFRC522 RFID' LIMIT 1), 'RFID RC522', 'Entrance', 'RST:A2 SS:D10 SPI:D11-13', FALSE, NULL),
((SELECT room_id FROM Room WHERE name = 'Living room' LIMIT 1), (SELECT type_id FROM Device_type WHERE model = '74HC08 (AND gate)' LIMIT 1), '74HC08 (AND gate)', 'Control board', NULL, FALSE, NULL);
