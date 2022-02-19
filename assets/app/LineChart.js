
import { Line, mixins } from '../vendor/vue-chartjs'
const { reactiveProp } = mixins

export default {
    extends: Line,
    //mixins: [reactiveProp],
    props: ['options'],
    data () {
        return {
        datacollection: null
        }
    },
    mounted () {
        this.fillData()
    },
    methods: {
        fillData () {
        this.datacollection = {
            labels: [this.getRandomInt(), this.getRandomInt()],
            datasets: [
                {
                    label: 'Data One',
                    backgroundColor: '#f87979',
                    data: [this.getRandomInt(), this.getRandomInt()]
                }, {
                    label: 'Data One',
                    backgroundColor: '#f87979',
                    data: [this.getRandomInt(), this.getRandomInt()]
                }
            ]
        }
        },
        getRandomInt () {
        return Math.floor(Math.random() * (50 - 5 + 1)) + 5
        }
    },
    template: `<div class="small">testing
        <line-chart :chart-data="datacollection"></line-chart>
        <button @click="fillData()">Randomize</button>
    </div>`
}