-- ============================================
-- xHome - 03_insert_data.sql
-- Sample data (adjust rooms, pins and extra components to your build)
-- ============================================

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
