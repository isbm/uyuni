/* eslint-disable */
// @flow
import ChildChannels from './child-channels';
import ActivationKeyChannelsApi from "./activation-key-channels-api";
import type {ChannelDto, availableChannelsType} from "./activation-key-channels-api";

import React from 'react';
import ReactDOM from 'react-dom';
import {Loading} from '../../components/loading/loading';
import withStatePersisted from '../../components/hoc/state-persisted/with-state-persisted';
import MandatoryChannelsApi from "../../core/api/mandatory-channels-api";

import {Utils} from '../../utils/functions';

const MandatoryChannelsApiStatePersisted = withStatePersisted(MandatoryChannelsApi);

declare function t(msg: string): string;
declare function t(msg: string, arg: string): string;

type ActivationKeyChannelsProps = {
  activationKeyId: number
}

type ActivationKeyChannelsState = {
  currentSelectedBaseId: number,
  currentChildSelectedIds: Array<number>,
}

class ActivationKeyChannels extends React.Component<ActivationKeyChannelsProps, ActivationKeyChannelsState> {
  constructor(props: ActivationKeyChannelsProps) {
    super(props);
    this.state = {
      currentSelectedBaseId: -1,
      currentChildSelectedIds: [],
    }
  }

  getDefaultBase(): ChannelDto {
    return { id: -1, name: t('SUSE Manager Default'), custom: false, subscribable: true, recommended: false};
  }

  handleBaseChange = (event: SyntheticInputEvent<*>): Promise<void> => {
    const newBaseId : number = parseInt(event.target.value);
    return new Promise((resolve: Function) =>
      this.setState(
        {currentSelectedBaseId: newBaseId},
        () => resolve(newBaseId)
      )
    );
  };

  handleChildChange = (event: SyntheticInputEvent<*>) => {
    this.selectChildChannels([parseInt(event.target.value)], event.target.checked);
  };

  selectChildChannels = (channelIds: Array<number>, selectedFlag: boolean) => {
    var selectedIds = [...this.state.currentChildSelectedIds];
    if (selectedFlag) {
      selectedIds = [...channelIds.filter(c => !selectedIds.includes(c)), ...selectedIds];
    }
    else {
      selectedIds = [...selectedIds.filter(c => !channelIds.includes(c))];
    }
    this.setState({currentChildSelectedIds: selectedIds});
  };

  onNewBaseChannel = ({currentSelectedBaseId, currentChildSelectedIds}: ActivationKeyChannelsState) => {
    this.setState({currentSelectedBaseId, currentChildSelectedIds});
  };

  renderChildChannels = (loadingChildren: boolean, availableChannels: availableChannelsType) => {
    return loadingChildren ?
      <Loading text='Loading child channels..' />
      : availableChannels.map(g => {
          const base = g.base;
          const channels = g.children.sort((c1, c2) => c1.name.localeCompare(c2.name));

          return (
            <MandatoryChannelsApiStatePersisted
              base={base}
              channels={channels}
              saveState={(state) => {
                this.state["ChildChannelsForBase" + (base ? base.id : 'no-base')] = state
              }}
              loadState={() => this.state["ChildChannelsForBase" + (base ? base.id : 'no-base')]}>
              {({
                  requiredChannels,
                  requiredByChannels,
                  dependencyDataAvailable,
                  dependenciesTooltip,
                  fetchMandatoryChannelsByChannelIds
                }) => (
                <ChildChannels
                  key={(base ? base.id : 'no-base')}
                  channels={channels}
                  base={(base ? base : new Object())}
                  showBase={availableChannels.length > 1}
                  selectedChannelsIds={this.state.currentChildSelectedIds}
                  selectChannels={this.selectChildChannels}
                  requiredChannels={requiredChannels}
                  requiredByChannels={requiredByChannels}
                  dependencyDataAvailable={dependencyDataAvailable}
                  dependenciesTooltip={dependenciesTooltip}
                  fetchMandatoryChannelsByChannelIds={fetchMandatoryChannelsByChannelIds}
                  collapsed={Array.from(availableChannels.keys()).length > 1}
                />
              )}
            </MandatoryChannelsApiStatePersisted>
          )
        }
      );
  };

  render() {
    return (
      <ActivationKeyChannelsApi
        onNewBaseChannel={this.onNewBaseChannel}
        defaultBaseId={this.getDefaultBase().id}
        activationKeyId={this.props.activationKeyId}
        currentSelectedBaseId={this.state.currentSelectedBaseId}>
        {
          ({
             messages,
             loading,
             loadingChildren,
             availableBaseChannels,
             availableChannels,
             fetchChildChannels
           }) => {

            if (loading) {
              return (
                <div className='form-group'>
                  <Loading text='Loading..' />
                </div>
              )
            }

            return (
              <div>
                <div className='form-group'>
                  <label className='col-lg-3 control-label'>{t('Base Channel:')}</label>
                  <div className='col-lg-6'>
                    <select name='selectedBaseChannel' className='form-control'
                            value={this.state.currentSelectedBaseId}
                            onChange={
                              (event) => this.handleBaseChange(event).then((newBaseId) => fetchChildChannels(newBaseId))
                            }>
                      <option value={this.getDefaultBase().id}>{this.getDefaultBase().name}</option>
                      {
                        availableBaseChannels
                          .sort((b1, b2) => b1.name > b2.name)
                          .map(b => <option key={b.id} value={b.id}>{b.name}</option>)
                      }
                    </select>
                    <span className='help-block'>
                      {t('Choose "SUSE Manager Default" to allow systems to register to the default SUSE Manager ' +
                        'provided channel that corresponds to the installed SUSE Linux version. Instead of the default, ' +
                        'you may choose a particular SUSE provided channel or a custom base channel, but if a system using ' +
                        'this key is not compatible with the selected channel, it will fall back to its SUSE Manager Default channel.')}
                    </span>
                  </div>
                </div>
                <div className='form-group'>
                  <label className='col-lg-3 control-label'>{t('Child Channels:')}</label>
                  <div className='col-lg-6'>
                    {this.renderChildChannels(loadingChildren, availableChannels)}
                    <span className='help-block'>
                      {t('Any system registered using this activation key will be subscribed to the selected child channels.')}
                    </span>
                  </div>
                </div>
              </div>
            )
          }
        }
      </ActivationKeyChannelsApi>
    )
  }
}

export default ActivationKeyChannels;
