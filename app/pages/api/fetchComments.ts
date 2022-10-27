// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from 'next'
import { Firestore } from '@google-cloud/firestore'

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
    
    const db = new Firestore()
    const commentsRef = db.collection('message-board').orderBy("createdAt", "asc")
    let array = []
    const snapshot = await commentsRef.get();
    console.log(snapshot.empty)
    snapshot.forEach(doc => {
      console.log(doc.data())
      array.push(doc.data())
    })

    res.status(200).json({messages:array})
}
