<template>
    <div id="app">
        <LineChart/>
    </div>
</template>

<script>
    import LineChart from "./LineChart.vue"
    
    export default {
        name: "App",
        components: {
            LineChart
        },
        data() {
            return {
                chartData: {
                    Books: 24,
                    Magazine: 30,
                    Newspapers: 10
                }
            };
        }
    }
</script>
