const express = require('express');
const { Client } = require('pg');
const bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.json());
const client = new Client({
  user: 'brandonwalden',
  host: 'localhost',
  database: 'vendingMachine',
  password: '',
  port: 5432
});
client.connect();

app.get('/', function(request, response) {
  response.send('Would you like a snack?');
});

app.get('/machines', function(request, response) {
  client.query('SELECT * FROM machine',
    function(request, dbResponse) {
      response.json({
        machines: dbResponse.rows
      })
    });
});

app.get('/machines/:machine_id', function(request, response) {
  client.query('SELECT * FROM machine WHERE machine_id =$1', [request.params.machine_id],
    function(request, dbResponse) {
      response.json({
        machine: dbResponse.rows[0]
      })
    });
});

app.get('/machines/:machine_id/snacks', function(request, response) {
  client.query('SELECT * FROM item WHERE machine_id =$1', [request.params.machine_id],
    function(request, dbResponse) {
      response.json({
        snacks: dbResponse.rows
      })
    });
});

app.get('/machines/:machine_id/purchaseHistory', function(request, response) {
  client.query('SELECT * FROM purchase WHERE machine_id =$1', [request.params.machine_id],
    function(request, dbResponse) {
      response.json({
        purchases: dbResponse.rows
      })
    });
});

app.post('/machines/:machine_id/snackTime', function(request, response) {
  var date = new Date();
  var payment = request.body.payment;
  var machine_id = request.params.machine_id;
  var item_id = request.body.item_id;

  client.query("SELECT cost from item WHERE item_id =$1", [request.body.item_id], function(request, dbResponse) {
    var price = dbResponse.rows[0].cost;
    var change = payment - price;
    console.log(price);
    console.log(payment);
    console.log(change);
    if (payment < price) {
      response.json({
        status: 'Failed',
        money_given: payment,
        cost: price
      })

    } else {
      client.query('INSERT into purchase(purchase_time,machine_id,item_id, payment,change) VALUES($1, $2, $3, $4, $5)', [date, machine_id, item_id, payment, change],
        function(err, dbResponse) {

          response.json({
            status: 'ok'
          })
        })
    }
  })

});

app.listen(3000, function() {
  console.log('Vending on port 3000...');
});
