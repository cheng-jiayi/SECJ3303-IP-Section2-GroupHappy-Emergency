function sendChat() {
    const msg = document.getElementById("msg").value;

    fetch(getContextPath() + "/chat/send", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ message: msg })
    })
    .then(res => {
        if (!res.ok) {
            return res.text().then(t => { throw new Error(t); });
        }
        return res.json();
    })
    .then(data => {
        // Use "message" key returned by backend
        document.getElementById("reply").innerText = data.message;
    })
    .catch(err => {
        document.getElementById("reply").innerText = err.message;
    });
}

function getContextPath() {
    return window.location.pathname.substring(
        0, window.location.pathname.indexOf("/", 2)
    );
}
