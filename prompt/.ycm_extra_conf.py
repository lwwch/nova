def FlagsForFile(filename, **kwargs):
    return {
        'flags' : [
            '-Wall',
            '-Wextra',
            '-Werror',
            '-pedantic',
            '-std=c99'
        ]
    }
