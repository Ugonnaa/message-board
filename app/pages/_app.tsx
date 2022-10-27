import '../styles/globals.css'
import { getFirestore, connectFirestoreEmulator } from "firebase/firestore"


function MyApp({ Component, pageProps }) {
  return <Component {...pageProps} />
}

export default MyApp