const express = require('express');
const app = express();
const MongoClient = require('mongodb').MongoClient;

app.use(express.json());

MongoClient.connect('mongodb+srv://user001:user001-mongodb-basics@practice.54zqw.mongodb.net/test?retryWrites=true&w=majority', {useUnifiedTopology: true}, (err, client) => {
    if (err) throw err;
    console.log('Database Connected');
    const dbProduct = client.db('product');
    const beansCollection = dbProduct.collection('beans');
    const dbTask003 = client.db('task003');
    const contactsCollection = dbTask003.collection('contacts');
    
    app.post('/beans', (req, res) => {
        if (!req.body.name) return res.status(400).send('Must have name');
        if (!Number.isInteger(req.body.qty)) return res.status(400).send('Quantity must be an Integer');

        const bean = {
            name: req.body.name,
            qty: req.body.qty
        };
        beansCollection.insertOne(bean);
        res.send(bean);
    });

    app.get('/beans', (req, res) => {
        dbProduct.collection('beans').find({}).toArray((err, result) => {
            if (err) throw err;
            res.send(result);
        });
    });

    app.get('/contacts', (req, res) => {
        contactsCollection.find({}).toArray((err, result) => {
            if (err) throw err;
            res.send(result);
        });
    });

    app.post('/contacts', (req, res) => {
        const contact = {
            last_name: req.body.last_name,
            first_name: req.body.first_name,
            phone_numbers: req.body.phone_numbers
        };
        contactsCollection.insertOne(contact);
        res.send(contact);
    });

    app.get('/contacts/total', (req, res) => {
        contactsCollection.count({}, (err, result) => {
            if(err) res.send(err);
            else res.json(result);
        })
    });
});

app.get('/', (req, res) => {
    res.send('Hello World');
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on port ${port}`)); 
