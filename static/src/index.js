import {init} from 'echarts';

const host = window.location.protocol + "//" + window.location.host;

console.log(host);

fetch(host + '/api/data', {
    method: 'POST',
}).then(text => {
    text.json().then(data => {
        var myChart = init(document.getElementById('main'), 'dark');
        // Specify the configuration items and data for the chart
        var option = {
            title: {
                text: data.reduce((a, b) => a + b.amount, 0) + "₽",
                textStyle: {
                    fontSize: 30,
                },
                left: 'center',
                top: 'center'
            },
            series: [
                {
                    type: 'pie',
                    itemStyle: {
                        normal: {
                            label: {
                                textStyle: {
                                    fontSize: 20,
                                },
                                show: true,
                                formatter: function (params) {
                                    return params.name + " " + params.value + "₽";
                                },
                            },
                        },
                    },
                    data: data.map(item => {
                        return {
                            name: item.name,
                            value: item.amount
                        }
                    }),
                    radius: ['40%', '70%']
                }
            ],

        };

        // Display the chart using the configuration items and data just specified.
        myChart.setOption(option);

    });
});