import React, { useEffect, useState } from 'react'
import Head from 'next/head'
import { default as PageTitle } from '../lib/components/PageTitle'
import Header from '../lib/components/Header'
import { Api } from '@mui/icons-material'
import { dateTime } from 'Luxon'

export default function Home(props) {
  // const [dates, setDates] = useState([] as string[])
  // const listItems = props.dates.map((date) =>
  // <li key={dates.toString()}>{dates}</li>
  // )
  const [comments, setComments] = useState([] as any)
  const [listItems, setListItems] = useState([] as any) 
  const handleSubmit = async (event) => {
    event.preventDefault()

    // Get data from the form.
    const data = {
      name: event.target.name.value,
      comment: event.target.comment.value,
    }

    // Send the data to the server in JSON format.
    const JSONdata = JSON.stringify(data)

    // API endpoint where we send form data.
    const endpoint = '/api/postComments'

    // Form the request for sending data to the server.
    const options = {
      // The method is POST because we are sending data.
      method: 'POST',
      // Tell the server we're sending JSON.
      headers: {
        'Content-Type': 'application/json',
      },
      // Body of the request is the JSON data we created above.
      body: JSONdata,
    }

    // Send the form data to our forms API on Vercel and get a response.
    const response = await fetch(endpoint, options)

    // Get the response data from server as JSON.
    // If server returns the name submitted, that means the form works.
    const result = await response.json()
    alert(`Is this your full name: ${result.data}`)
  }
  useEffect(()=> {
    fetch('http://localhost:3000/api/fetchComments')
      .then((response) => response.json())
      .then((data) => setComments(data.messages))
  },[])
  useEffect(()=>{
    const sortedComments = comments.sort(function(a,b){
      return (a.createdAt._seconds < b.createdAt._seconds?1:-1)
    })
    setListItems(sortedComments.map((comment) =>
      <li>{comment.comment}</li>
    ))
    console.log(listItems)
  },[comments])
  useEffect(()=>
  {
    console.log(listItems)
  },[listItems])

  return (
    <>
      <PageTitle title="Message Board"></PageTitle>
      <Head>
        <title>Message Board App</title>
        <h1>Message Board App</h1>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <form onSubmit={handleSubmit}>
        <label htmlFor="name">Name:</label><br/>
        <input type="text" id="name" name="name"/><br/>
        <label htmlFor="comment">Comment:</label><br/>
        <textarea id="comment" name="comment"></textarea>
        <input type="submit" value="Submit"/>
      </form>
      <ul>
          {listItems}
        </ul>
    </>
  )
}
