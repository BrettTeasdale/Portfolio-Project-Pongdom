chartData = function(){
    return {
        data: null,
        fetch: function(){
            fetch('/requests/1/data').then(res => res.json()).then(res => {
                this.data = res;
                this.renderChart();
            })
        },
        renderChart: function(){
            let c = false;

            Chart.helpers.each(Chart.instances, function(instance) {
                if (instance.chart.canvas.id == 'chart') {
                    c = instance;
                }
            });

            if(c) {
                c.destroy();
            }

            let ctx = document.getElementById('chart').getContext('2d');
            
            let chart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: this.data.y,
                    datasets: [
                        {
                            label: "Response Time (ms)",
                            backgroundColor: "rgba(100, 100, 225, 0.25)",
                            borderColor: "rgba(50, 50, 175, 1)",
                            pointBackgroundColor: "rgba(102, 126, 234, 1)",
                            data: this.data.x,
                        }
                    ]
                }
            });
        }
    }
}