# TC1004B-IoT — xHome Smart Home

This implementation of the Internet of Things is an academic smart home prototype.

An **Arduino UNO R4 WiFi**, a **MySQL/MariaDB** database (XAMPP), a local **Mosquitto MQTT** broker, and a   **React** web dashboard were used.

---

## Current pinout

> [!note] Draft
> Pin assignments might change during the final physical wiring, and additional LEDs might be added.

| `Room` | `Device` | Current Pin |
| :--- | :--- | :--- |
| **Living room** | SSD1306 (OLED Display) | `SDA`, `SCL` (I2C) |
| **Living room** | BME280 (Temp and Humidity) | `SDA`, `SCL` (I2C) |
| **Living room** | Push Button | `D4` |
| **Bedroom** | LED Bedroom (`led1`) | `D6` |
| **Bathroom** | LED Bathroom (`led2`) | `D7` |
| **Garage** | LED Garage (`led3`) | `D8` |
| **Garage** | Servo MG90S *(door pending)* | `D5` |
| **Exterior** | Rain Sensor | `A0`, `D2` |
| **Exterior** | Proximity Sensor | `SDA`, `SCL` (I2C) |
| **Exterior** | Buzzer | `D3` |
| **Exterior** | RFID RC522 | `RST: A2`, `SS/SDA: D10`, `MOSI: D11`, `MISO: D12`, `SCK: D13` |

The implementation of the NE555 is still pending, however this is a permanent pinout layout.

---

## Database overview 

- `Room`: 5 spaces (`Living room`, `Bathroom`, `Bedroom`, `Exterior`, `Garage`).
- `Device_type`: Catalog of sensors, actuators, access readers, and logic gates.
- `Device`: Supports variable numbers of LEDs per room, `arduino_pin`, `is_controllable`, and `current_state` for dashboard sync.
- `Users`: Registered users (`Admin`, `Resident 1`, `Carlos`, `Bernardo`, `Pablo`) with `rfid_uid` and `is_active` status.
- `Measurements`: Numeric sensor readings (`BME280`, rain, proximity).
- `Events_actuators`: History of actuator actions (`dashboard`, `physical`, or `auto`).
- `Access_logs`: History of RFID card scans.

---

## Database Setup 
### Linux
> [!TIP] Pre-requisites
> - Install [XAMPP](https://sourceforge.net/projects/xampp/) or MariaDB/MySQL
> - Recommended MySQL port: `3307` (to avoid conflicts with other local services)
> - Install a GUI client: [DBeaver-ce](https://dbeaver.io/download/) or VS Code SQL extensions.

1. Start XAMPP:
   ```bash
   sudo /opt/lampp/lampp start
   ```
2. Access MySQL from the terminal:
   ```bash
   sudo /opt/lampp/bin/mysql -u root -P 3307
   ```
3. Run either: 
   - `database/script.sql` for a clean full setup, 
   - or `01_create_database.sql`, `02_create_tables.sql`, `03_insert_data.sql` in order.

### Windows
> [!TIP] Pre-requisites

---

## Changelog

### [v0.2.0] - 2026-11-23
Database
- Updated database to match the final 5 spaces on the physical prototype (`Living room`, `Bathroom`, `Bedroom`, `Exterior`, `Garage`).
   - Moved database scripts directly under `database/`
   - Keeping a consolidated and clean script in `database/script.sql`.
- Added `rfid_uid` and `is_active` to `Users`.
- Added `Access_logs` table. This allows the usage of RFID cards.
- Added users: `Carlos`, `Bernardo`, and `Pablo`.
- Added columns for dashboard: `is_controllable`, `current_state`, and wider-data-type `arduino_pin` to `Device`. 
- Added `source` to `Events_actuators` in order to control LEDs per room from the dashboard.

Source folder
- Replaced `src/main.py` placeholder with `src/arduino/`, `src/backend/`, and `src/dashboard/` folders.
   - Preparing the file's architecture for a local **Mosquitto MQTT** broker.

### [v0.1.0] - 2026-10-16
Initial repo structure
- Arduino UNO R4 WiFi (`ABX00087`) datasheet
- Initial MySQL database
- Database backup (`xhome_backup-16-10-2026.sql`).
