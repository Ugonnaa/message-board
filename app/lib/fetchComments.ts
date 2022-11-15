import { Comment } from '../typings'

export const fetchComments = async (commentId: string ) => {
    const res = await fetch(`/api/getComments?commentId=${commentId}`)

    const comments: Comment[] = await res.json()

    return comments
}

// sofnQg8ExeQnN2jf4pZX