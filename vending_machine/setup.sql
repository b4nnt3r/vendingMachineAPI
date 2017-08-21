DROP DATABASE IF EXISTS vendingMachine;
CREATE DATABASE vendingMachine;

\c vendingMachine;

CREATE TABLE machine(
  machine_id SERIAL PRIMARY KEY,
  bank FLOAT,
  location TEXT
);

CREATE TABLE item(
  item_id SERIAL PRIMARY KEY,
  cost FLOAT,
  name TEXT,
  amount INTEGER
  machine_id INTEGER REFERENCES machine
);


CREATE TABLE purchase(
  purchase_id SERIAL PRIMARY KEY,
  purchase_time TIMESTAMP,
  machine_id INTEGER REFERENCES machine,
  item_id INTEGER REFERENCES item,
  payment FLOAT,
  change FLOAT
);

INSERT INTO machine (bank, location)
VALUES(200.00, '1st Floor'),
      (100.00, '2nd Floor'),
      (50.50, '3rd Floor');

INSERT INTO item (cost, name, amount, machine_id)
VALUES
  (1.00,'Reeses Cups King Size',12,(SELECT machine_id FROM machine WHERE location='1st Floor')),
  (0.75,'Skittles',10,(SELECT machine_id FROM machine WHERE location ='1st Floor')),
  (0.75,'Nutri Bar Apple',6,(SELECT machine_id FROM machine WHERE location ='1st Floor')),
  (1.00,'Lays Chips',10,(SELECT machine_id FROM machine WHERE location='2nd Floor')),
  (1.00,'7UP',8,(SELECT machine_id FROM machine WHERE location='1st Floor')),
  (0.25,'Wrigleys Gum',12,(SELECT machine_id FROM machine WHERE location='2nd Floor')),
  (1.00,'Sprite',7,(SELECT machine_id FROM machine WHERE location='3rd Floor')),
  (1.00,'Coca-Cola',5,(SELECT machine_id FROM machine WHERE location='3rd Floor')),
  (7.00,'Smokes',10,(SELECT machine_id FROM machine WHERE location='3rd Floor'));




INSERT INTO purchase
VALUES('2017-08-17 09:00:00',(SELECT machine_id FROM machine WHERE location='2nd Floor'),(SELECT item_id FROM item WHERE name='Wrigleys Gum'), 5.00, 4.75),
('2017-08-17 13:45:00',(SELECT machine_id FROM machine WHERE location='1st Floor'),(SELECT item_id FROM item WHERE name='7UP'),1.00,0),
('2017-08-16 12:15:00',(SELECT machine_id FROM machine WHERE location='3rd Floor'),(SELECT item_id FROM item WHERE name='Smokes'), 10.00, 3.00);

SELECT * FROM machine;
SELECT * FROM item;
SELECT * FROM purchase;
