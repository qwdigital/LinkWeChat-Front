<script>
  export default {
    name: 'MenuItem',
    functional: true,
    data () {
      return {
        titleStyle: {
          color: '#f5f5f5',
        }
      }
    },
    props: {
      icon: {
        type: String,
        default: ''
      },
      title: {
        type: String,
        default: ''
      },
      isSub: {
        type: Boolean,
        default: true
      }
    },
    render (h, context) {
      const { icon, title } = context.props
      const vnodes = []

      // if (icon) {
      //   vnodes.push(<svg-icon icon-class={icon}/>)
      // }

      if (title) {
        vnodes.push(<span slot='title'>{(title)}</span>)
      }
      return vnodes
    }
  }
</script>
