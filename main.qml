import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello Square")

    property var points: []
    Canvas {
        id: canvas
        anchors.fill: parent
        property var ctx: null

        property int rough: 1

        onPaint: {
            drawLine(ctx, canvas)
        }

        MouseArea {
            id:mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPressed: {
                if((mouseArea.pressedButtons & Qt.RightButton) == 0) {
                    var tmp = points
                    tmp = 0
                    tmp = [mouseX, mouseY]
                    points.push(tmp)
                }

                if(points.length === 2){
                    points[0][0] = 0
                    points[1][0] = width
                    canvas.requestPaint()
                }
            }
        }

        Button {
            id: plus
            text: "+"

            onClicked: {
                canvas.rough += 1
                //canvas.clear()
                canvas.requestPaint()
            }
        }

        Button {
            text: "GO!"

            anchors {
                left: plus.right
                leftMargin: 10
            }

            onClicked: {
                canvas.doDiamondSquare()
                canvas.clear()
                canvas.requestPaint()
            }
        }

        function drawLine(ctx, canvas){

            if(points.length < 2){
                return
            }

            ctx = canvas.getContext("2d");

            ctx.lineWidth = 1;
            ctx.strokeStyle = "limegreen"

            ctx.beginPath()
            ctx.moveTo(points[0][0], points[0][1])
            for(var i = 1; i < points.length; i ++){
                ctx.lineTo(points[i][0], points[i][1])
            }
            ctx.stroke()
        }

        function clear(){
            ctx = getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height)
        }

        function doDiamondSquare(){
            //h = (hL + hR) / 2 + random(- R * l, R * l)

            var newPpoints = []
            for(var i = 0; i < points.length - 1; i++){
                var l = Math.abs(points[i + 1][0] - points[i][0])
                var hl = points[i][1]
                var hr = points[i + 1][1]
                var h = (hl + hr) / 2 + randomInteger(-rough * l, rough * l)

                var newX = (points[i + 1][0] + points[i][0]) / 2

                if(h < 0){
                    h = 0
                } else if (h > root.height){
                    h = root.height
                }

                newPpoints.push(points[i][0], hl)
                newPpoints.push(newX, h)
                newPpoints.push(points[i + 1][0], hr)
            }

            points = []

            for(i = 0; i < newPpoints.length - 1; i += 2){
                var tmp = [newPpoints[i], newPpoints[i + 1]]
                points.push(tmp)
            }
        }

        function randomInteger(min, max) {
            var rand = min - 0.5 + Math.random() * (max - min + 1)
            rand = Math.round(rand)

            if(rand < 0){
                return 0
            }
            else if(rand > root.height){
                return root.height
            }
            else {
                return rand
            }
        }
    }
}












