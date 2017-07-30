//send userId to server to launch userAnalysis sequence
function analyzeUser(userId) {
    console.log(userId, "User ID");
    Shiny.onInputChange("requestUserAnalysis", [userId,Math.random()]);
}

// Simulate Button Click take one param id of button
Shiny.addCustomMessageHandler("simulateButtonClick", function (buttonName) {
    $(buttonName).click();
})
