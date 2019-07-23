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
    posts:  async function(req, res) {
        try {
            const posts = await Post.find()
            res.send(posts)
        } catch (err) {
            res.serverError(err.toString() )
        }
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
            return res.redirect('/home')
            res.end()
        })
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
    },

    delete: async function(req, res) {
        const postId = req.param('postId')

        await Post.destroy({id: postId})
        res.send('Finished deleting post')
    }

}