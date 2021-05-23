exports.get = async (req, res, next) => {
    res.status(200).send({
        mensagem: 'OK!'
    })
}
