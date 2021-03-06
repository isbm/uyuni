/* eslint-disable */
"use strict";

const React = require("react");
const PropTypes = React.PropTypes;

// use this mixin to persist an element's state between mounts
const StatePersistedMixin = {
  propTypes: {
    saveState: PropTypes.func, // is called before unmount
    loadState: PropTypes.func, // is called on mount
  },

  componentWillUnmount: function() {
    if (this.props.saveState) {
      this.props.saveState(this.state);
    }
  },

  componentWillMount: function() {
    if (this.props.loadState) {
      if (this.props.loadState()) {
        this.state = this.props.loadState();
      }
    }
  },
};

module.exports = {
    StatePersistedMixin : StatePersistedMixin
}
