module.exports = async function(req, res) {
    console.log("This route shows homa page of posts")

    const userId = req.session.userId
    const allPosts = await Post.find({user: userId})

    if (req.wantsJSON) {
        res.send(allPosts)
    }

    res.view('pages/home',
    {allPosts}
    )
}