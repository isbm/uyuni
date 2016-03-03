'use strict';

const React = require("react");
const Buttons = require("../components/buttons");
const AsyncButton = Buttons.AsyncButton;
const Panel = require("../components/panel").Panel
const Table = require("../components/table2").Table
const Functions = require("../utils/functions")
const Comparators = Functions.Comparators;
const Filters = Functions.Filters;
const Renderer = Functions.Renderer;


function listKeys() {
    return $.get("/rhn/manager/api/minions/keys");
}

function minionToList(idFingerprintMap, state) {
   return Object.keys(idFingerprintMap).map(key => {
       return {
           "id": key,
           "fingerprint": idFingerprintMap[key],
           "state": state
       };
   });
}

function processData(keys) {
   return ["minions", "minions_rejected", "minions_pre", "minions_denied"].reduce((acc, key) => {
       return acc.concat(minionToList(keys[key], key));
   }, []);
}

function acceptKey(key) {
    return $.post("/rhn/manager/api/minions/keys/" + key + "/accept");
}

function deleteKey(key) {
    return $.post("/rhn/manager/api/minions/keys/" + key + "/delete");
}

function rejectKey(key) {
    return $.post("/rhn/manager/api/minions/keys/" + key + "/reject");
}

function actionsFor(id, state, update) {
    const acc = () => <AsyncButton key="accept" title="accept" icon="check" action={() => acceptKey(id).then(update)} />;
    const rej = () => <AsyncButton key="reject" title="reject" icon="times" action={() => rejectKey(id).then(update)} />;
    const del = () => <AsyncButton key="delete" title="delete" icon="trash" action={() => deleteKey(id).then(update)} />;
    const mapping = {
        "minions": [del],
        "minions_pre": [acc, rej],
        "minions_rejected": [del],
        "minions_denied": [del]
    };
    return (
      <div className="pull-right btn-group">
         { mapping[state].map(fn => fn()) }
      </div>
    );
}

const stateMapping = {
    "minions": {
        uiName: t("accepted"),
        label: "success"
    },
    "minions_pre": {
        uiName: t("pending"),
        label: "info"
    },
    "minions_rejected": {
        uiName: t("rejected"),
        label: "warning"
    },
    "minions_denied": {
        uiName: t("denied"),
        label: "danger"
    }
}

const stateUiName = (state) => stateMapping[state].uiName;

function labelFor(state) {
    const mapping = stateMapping[state];
    return <span className={"label label-" + mapping.label}>{ mapping.uiName }</span>
}

class Onboarding extends React.Component {

  constructor(props) {
    super();
    ["reloadKeys"].forEach(method => this[method] = this[method].bind(this));
    this.state = {
        keys: []
    };
    this.reloadKeys();
  }

  reloadKeys() {
    return listKeys().then(data => {
        this.setState({
            keys: processData(data)
        });
    });
  }

  render() {
    const minions = this.state.keys;
    const panelButtons = <div className="pull-right btn-group">
      <AsyncButton id="reload" icon="refresh" name="Refresh" text action={this.reloadKeys} />
    </div>;

    return (
        <Panel title="Onboarding" icon="fa-desktop" button={ panelButtons }>
            <Table
                data={ minions }
                keyFn={ entry => entry.id + entry.fingerprint }
                options={{
                }}
                columns={[
                  {
                      "header": t("Name"),
                      "entryToCell": (entry) => entry.id,
                      "renderCell": Renderer.highlightSubstring,
                      "sort": Comparators.locale,
                      "filter": Filters.substring,
                      "ratio": 0.3
                  },{
                      "header": t("Fingerprint"),
                      "entryToCell": (entry) => entry.fingerprint,
                      "renderCell": Renderer.highlightSubstring,
                      "sort": Comparators.locale,
                      "filter": Filters.substring,
                      "ratio": 0.5
                  },{
                      "header": t("State"),
                      "entryToCell": (entry) => entry.state,
                      "renderCell": (cell) => labelFor(cell),
                      "sort": Comparators.mapping(Comparators.locale, stateUiName),
                      "filter": Filters.mapping(Filters.substring, stateUiName),
                      "ratio": 0.1
                  },{
                      "header": t("Actions"),
                      "entryToCell": (entry) => entry,
                      "renderCell": (cell) => actionsFor(cell.id, cell.state, this.reloadKeys),
                      "ratio": 0.1
                  }
                ]}
            />
        </Panel>
    );
  }

}

React.render(
  <Onboarding />,
  document.getElementById('onboarding')
);
