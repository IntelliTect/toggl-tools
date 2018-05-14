const mongodb = require('mongodb')
const mongo = mongodb.MongoClient

const url = 'mongodb://localhost:27017/toggl'
const collectionName = 'students'

console.log('url: '+url)

mongo.connect(url, (err, db) => {
	if (err) {
		console.log('Error connecting to db: '+err)
		return process.exit(1)
	}
	console.log('connected')
	// console.log('connected: ' + db.url)

	const collection = db.collection(collectionName)
    collection.insert([{name:'bob'}, {nane:'John'}, {name:'Peter'}], 
        (error, result) => {
            if (error) {
                console.log('error inserting '+error)
                return process.exit(1)
            }
            console.log(result.result)
            console.log(result.ops.length)
            console.log('inserted docs')
            // callback(result)
        }
    )
	//	var time = db.collection('entries')

//	setTimeout(getDetailedReport, 2000, time, togglWorkspace, projectId);
	
	db.close()
})

// function ScheduleRequest() {
// 	mongo.connect(url, (err, db) => {
// 		if (err) {
// 			console.log('Error connecting to db: '+err)
// 			return process.exit(1)
// 		}
// 		var time = db.collection('entries')
// 		getDetailedReport()
// 		console.log('done with the first one')
// 		// db.close()
// 	})
// }


console.log('ended')



