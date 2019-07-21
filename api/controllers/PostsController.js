// dummy database 
// const post1 = {id: 1,
//     title: 'Something',
//     body: 'Body'
// }
// const post2 = {id: 2,
//     title: 'Something 2',
//     body: 'Body 2'
// }
// const post3 = {id: 3,
//     title: 'Something 3',
//     body: 'Body 3'
// }

// const allPosts = [post1, post2, post3]

module.exports = {
    posts: function(req, res) {
        Post.find().exec(function(err, posts) {
            res.send(posts)
        })
        // res.send(allPosts)
    },

    create: function(req, res) {
        const title = req.body.title
        const postBody = req.body.postBody

        sails.log.debug('Titlte:' + title)
        sails.log.debug('Body:' + postBody)

        Post.create({title: title, body: postBody}).exec(function(err){
            if (err) {
                return res.serverError(err.toString())
            }
            console.log("Finished creating post object")
            res.end()
        })
        // const newPosts = {id: 4,
        //     title: title,
        //     body: postBody}
        // allPosts.push(newPosts) 

        // res.end()
    },

    findById:  function(req, res) {
        const postId = req.param('postId')

        const filterPosts = allPosts.filter(p => {
            return p.id == postId
        })
        if (filterPosts.length > 0) {
            res.send(filterPosts[0])
        } else {
            res.send('Failed to find post by id:' + postId)
        }
    }

}