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