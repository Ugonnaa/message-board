// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from 'next'
// import { Comment } from '../../typings'
import { Firestore } from '@google-cloud/firestore'


export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
    const comment = {
        ...req.body, 
        createdAt: new Date()
    }
    const firestore = new Firestore()
    const collection = firestore.collection('message-board')
    const doc = await collection.add(comment);
    console.log(req.body)
    res.status(200).send({})
}
