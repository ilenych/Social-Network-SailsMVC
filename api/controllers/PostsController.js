// dummy database 
const post1 = {id: 1,
    title: 'Something',
    body: 'Body'
}
const post2 = {id: 2,
    title: 'Something 2',
    body: 'Body 2'
}
const post3 = {id: 3,
    title: 'Something 3',
    body: 'Body 3'
}

const allPosts = [post1, post2, post3]

module.exports = {
    posts: function(req, res) {
        res.send(allPosts)
    },

    create: function(req, res) {
        const title = req.param('title')
        const body = req.param('body')
        console.log(title + ' ' + body)
        const newPosts = {id: 4,
            title: title,
            body: body}
        allPosts.push(newPosts)

        res.end()
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