import socket from "./socket"

const channel           = socket.channel("aquarium:state", {})
const body              = $("body")
const aquarium          = $("#aquarium")
const fishDisplay       = $("#fish_display")
const scoreElement      = $("#score")
let score               = 0

channel.on("fish_added", payload => {
  placeFishAt(payload.fish, payload.place)
})

channel.on("fish_moved", payload => {
  removeFish(payload.fish)
  placeFishAt(payload.fish, payload.place)
})

channel.on("fish_removed", payload => {
  removeFish(payload.fish)
})

channel.join()
  .receive("ok", response => { joinGame(response.fish, response.place)})
  .receive("error", response => { console.log("Unable to join", resp) })

function joinGame(fish, place) {
  console.log("Joined the game")

  if (!fish) {
    fishDisplay.removeClass().text("No fish available. Try again later");
    return;
  }

  cleanup(fish)
  fishDisplay.removeClass().addClass(fish)

  body.on("keypress", e => {
    let dir = direction(e.which)
    channel.push("move_fish", {dir: dir, fish: fish })
  })

  channel.on("fish_killed", payload => { handleKilling(payload.killer, payload.killed, fish) })

  channel.push("fish_added", {fish: fish, place: place})
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

function handleKilling(killer, killed, self) {
  if (killed === self) {
    score = 0
    scoreElement.text(score)
    channel.push("fish_added", {fish: self, place: {x: 0, y: 0}})
  }
  if (killer === self) {
    scoreElement.text(++score)
  }
}

function cleanup(fish) {
  removeFish(fish) // in case this is a page reload
  body.off() // in case this is a channel rejoin
}
