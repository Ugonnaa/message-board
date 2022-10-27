import React, { FunctionComponent } from 'react'
import Head from 'next/head'

interface Props {
  title?: string
}

const PageTitle: FunctionComponent<Props> = ({ title }) => (
  <Head>
    <title>{['Message-Board', title].filter(Boolean).join(' | ')}</title>
    <link rel="icon" href="/favicon.ico" />
  </Head>
)

export default PageTitle
