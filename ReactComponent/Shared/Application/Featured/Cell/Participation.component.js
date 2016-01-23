/**
 * Created by bruceli on 15-11-24.
 */

"use strict";

/*****************************
*    External Dependencies   *
******************************/

import React, {
  View,
  Dimensions,
  Component,
  StyleSheet,
  PropTypes
} from "react-native";

/*****************************
*    Internal Dependencies   *
******************************/

import ParticipationPictures from "./ParticipationPictures.component";
import ParticipationStats from "./ParticipationStats.component";

/*****************************
*          Constants         *
******************************/

const DEVICE_WIDTH = Dimensions.get("window").width;

const PARTICIPATION_HEIGHT_RATIO = 0.17;
const PARTICIPATION_WIDTH_OFFSET = 20;
const PROFILE_WIDTH_RATIO = 0.63;

/*****************************
*            Code            *
******************************/
const styles = StyleSheet.create({

  participationView: {
    marginLeft: 10,
    flexDirection: "row",
    justifyContent: "flex-start",
    backgroundColor: "#F6F6F6",
    height: DEVICE_WIDTH * PARTICIPATION_HEIGHT_RATIO,
    width: DEVICE_WIDTH - PARTICIPATION_WIDTH_OFFSET
  },
  profilesView: {
    flexDirection: "row",
    justifyContent: "flex-start",
    backgroundColor: "#F6F6F6",
    width: DEVICE_WIDTH * PROFILE_WIDTH_RATIO
  }

});

export default class ParticipationInfoView extends Component {

  static propTypes = {
    data: PropTypes.shape({
      treatCount: PropTypes.number,
      toGoCount: PropTypes.number,
      userProfilePreviewUrls: PropTypes.arrayOf(PropTypes.string)
    })
  };

  render() {

    const {
      data: {
        treatCount,
        toGoCount,
        userProfilePreviewUrls
      }
    } = this.props;

    return (
      <View style={styles.cellContainer}>
        <View style={styles.participationView}>
          <ParticipationPictures data={{
            userProfilePreviewUrls
          }}/>
          <ParticipationStats data={{
            treatCount,
            toGoCount
          }}/>
        </View>
      </View>
    );
  }
}
