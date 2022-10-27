// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from 'next'
import { Firestore } from '@google-cloud/firestore'


export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {

    const firestore = new Firestore()
    const document = firestore.doc('message-board/http://localhost:4000/firestore/data/message-board')
    const doc = await document.get();

  res.status(200).json(doc)
}
