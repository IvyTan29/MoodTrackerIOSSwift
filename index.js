import express from 'express'
import mongoose from 'mongoose'
import { router } from './routes/userRoutes.js'
import session from 'express-session'
import 'dotenv/config'

const PORT = process.env.PORT || 8080;

const app = express();

app.use(express.json())
app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true
}));
app.use('/user', router)

mongoose.connect(`mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@cluster0.rmpuw.mongodb.net/MoodTracker?retryWrites=true&w=majority`, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  }).then(() => {
    console.log("Successfull connected to the database!!")
  }).catch(err => {
    console.log(err)
    console.log("Could not connect to the database. Will attempt to reconnect later...")
  });


app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});



