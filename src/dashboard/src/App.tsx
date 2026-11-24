import { useEffect, useState } from 'react'
import heroImg from './assets/hero.png'
import reactLogo from './assets/react.svg'
import viteLogo from './assets/vite.svg'
import './App.css'
import mqtt from 'mqtt'

function App() {
  const [count, setCount] = useState(0)
  const [msg, setMsg] = useState('Nada publicado')
  const [channel, setChannel] = useState('Desconocido')

  useEffect(() => {
    const client = mqtt.connect('ws://127.0.0.1:8080', {
      protocol: 'ws',
      clientId: `A01663510-${Math.random().toString(16).slice(2, 6)}`,
    })

    client.on('connect', () => {
      client.subscribe('mensajesTec')
      client.subscribe('xhome/#')
    })

    client.on('message', (topic, message) => {
      setMsg(message.toString())
      setChannel(topic.toString())
      console.log(topic, message.toString())
    })

    return () => {
      client.end()
    }
  }, [])

  return (
    <>
      <section id="center">
        <div className="hero">
          <img src={heroImg} className="base" width="170" height="179" alt="" />
          <img src={reactLogo} className="framework" alt="React logo" />
          <img src={viteLogo} className="vite" alt="Vite logo" />
        </div>
        <div>
          <h1>{msg}</h1>
          <p>
            Canal <code>{channel}</code>
          </p>
        </div>
        <button
          type="button"
          className="counter"
          onClick={() => setCount((count) => count + 1)}
        >
          Count is {count}
        </button>
      </section>
    </>
  )
}

export default App
