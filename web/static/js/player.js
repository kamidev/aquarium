import socket from "./socket"

const channel           = socket.channel("aquarium:state", {})
const body              = $("body")
const aquarium          = $("#aquarium")
const myFish            = "tangerine"

channel.on("fish_moved", payload => {
  removeFish(payload.fish)
  placeFishAt(payload.fish, payload.place)
})

channel.join()
  .receive("ok", response => { joinGame(response)})
  .receive("error", response => { console.log("Unable to join", resp) })

function joinGame(response) {
  console.log("Joined the game")
  body.on("keypress", e => {
    let dir = direction(e.which)
    channel.push("move_fish", {dir: dir, fish: myFish })
  })
}

function direction(keycode) {
  switch (keycode) {
    case 106:
      return "down"
    case 107:
      return "up"
    case 104:
      return "left"
    case 108:
      return "right"
    default:
      return "ignore"
  }
}

function removeFish(fish) {
  let currentPos = aquarium.find("." + fish)
  currentPos.removeClass().addClass("empty")
}

function placeFishAt(fish, position) {
  let x = position.x
  let y = position.y
  let newPos = aquarium.find("[data-x=" + x + "][data-y=" + y + "]")
  newPos.removeClass().addClass(fish)
}
