vim.filetype.add({
    extension = {
        tf = 'terraform',
        tfvars = 'terraform'
    },
    pattern = {
        ['Jenkinsfile*'] = 'groovy',
        ['jenkinsfile*'] = 'groovy'
    }
})
