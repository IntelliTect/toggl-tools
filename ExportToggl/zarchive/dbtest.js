const mongodb = require('mongodb')
const mongo = mongodb.MongoClient

const url = '<dburl>'

mongo.connect(url, (err, db) => {
    if (err) {
        console.log('Error connecting to db: '+err)
        return process.exit(1)
    }
    var time = db.collection('projectentries')
    console.log('connected')

    var results = time.aggregate([
        { $sort: { badfieldname: -1 }}
        // ,{ $limit: 1}
        // ,{ $group: {_id: "$item", lastSalesDate: { $last: "$date" }}
    ]).forEach(doc => {
        console.log('doc: '+JSON.stringify(doc));
    })

    // console.log('results:'+results.count());
    return process.exit(1);
})
