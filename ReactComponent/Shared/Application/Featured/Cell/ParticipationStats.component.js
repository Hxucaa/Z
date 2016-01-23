/**
 * Created by bruceli on 15-11-24.
 */

"use strict";

import React, {
  Text,
  View,
  Dimensions,
  Component,
  StyleSheet,
  PropTypes
} from "react-native";

// import { createIconSetFromFontello } from "react-native-vector-icons";

// import fontelloConfig from "../../../../assets/fontello/config.json";
// const CustomIcon = createIconSetFromFontello(fontelloConfig);

const DEVICE_WIDTH = Dimensions.get("window").width;

const STATS_VIEW_WIDTH_RATIO = 0.37;
const STATS_VIEW_WIDTH_OFFSET = 21;
const HEART_ICON_SIZE = 18;
const BILL_ICON_SIZE = 20;

const styles = StyleSheet.create({
  statsView: {
    marginRight: 10,
    flexDirection: "row",
    justifyContent: "center",
    width: DEVICE_WIDTH * STATS_VIEW_WIDTH_RATIO - STATS_VIEW_WIDTH_OFFSET
  },
  // wtgIcon: {
  //   marginLeft: 0,
  //   marginTop: 23,
  //   fontFamily: "lai-icons",
  //   color: "#00B2AC"
  // },
  toGoCount: {
    marginLeft: 1,
    fontSize: 11,
    marginTop: 28,
    color: "#00B2AC",
    height: 17
  },
  dot: {
    marginLeft: 0,
    fontSize: 12,
    fontWeight: "bold",
    marginTop: 24,
    width: 15,
    textAlign: "center",
    color: "#00B2AC"
  },
  // treatIcon: {
  //   marginLeft: 0,
  //   marginTop: 23,
  //   fontFamily: "lai-icons",
  //   color: "#00B2AC"
  // },
  treatCount: {
    marginTop: 28,
    marginLeft: 1,
    marginRight: 5,
    height: 17,
    fontSize: 11,
    color: "#00B2AC"
  }
});

export default class ParticipationStats extends Component {

  static propTypes = {
    data: PropTypes.shape({
      treatCount: PropTypes.number.isRequired,
      toGoCount: PropTypes.number.isRequired
    }).isRequired
  };

  render() {

    const {
      data: {
        treatCount,
        toGoCount
      }
    } = this.props;

    return (
      <View style={styles.statsView}>
        <Text style={styles.toGoCount}>{toGoCount}</Text>
        <Text style={styles.dot}>{'・'}</Text>
        <Text style={styles.treatCount}>{treatCount}</Text>
      </View>
    );
  }
}

  // <View style={styles.statsView}>
  //   <CustomIcon name="heart" style={styles.wtgIcon}
  //     size={HEART_ICON_SIZE}/>
  //   <Text style={styles.wtgStat}>{'55'}</Text>
  //   <Text style={styles.dot}>{'・'}</Text>
  //   <CustomIcon name="bill-unfilled" style={styles.treatIcon}
  //     size={BILL_ICON_SIZE}/>
  //   <Text style={styles.treatStat}>{'55'}</Text>
  // </View>
