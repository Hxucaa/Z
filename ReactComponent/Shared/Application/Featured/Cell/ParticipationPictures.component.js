/**
 * Created by bruceli on 15-11-24.
 */

"use strict";

/*****************************
*    External Dependencies   *
******************************/

import React, {
  Image,
  View,
  Dimensions,
  Component,
  StyleSheet,
  PropTypes
} from "react-native";

/*****************************
*    Internal Dependencies   *
******************************/


/*****************************
*          Constants         *
******************************/
const DEVICE_WIDTH = Dimensions.get("window").width;

const PROFILES_VIEW_WIDTH_RATIO = 0.63;
const PROFILE_IMG_BORDER_RADIUS_RATIO = 0.056;
const PROFILE_IMG_WIDTH_RATIO = 0.11;
const PROFILE_IMG_HEIGHT_RATIO = 0.112;

/*****************************
*            Code            *
******************************/

const styles = StyleSheet.create({

  profilesView: {
    flexDirection: "row",
    justifyContent: "flex-start",
    backgroundColor: "#F6F6F6",
    width: DEVICE_WIDTH * PROFILES_VIEW_WIDTH_RATIO
  },
  profileImg: {
    marginLeft: 5,
    marginTop: 10,
    borderRadius: DEVICE_WIDTH * PROFILE_IMG_BORDER_RADIUS_RATIO,
    width: DEVICE_WIDTH * PROFILE_IMG_WIDTH_RATIO,
    height: DEVICE_WIDTH * PROFILE_IMG_HEIGHT_RATIO
  }
});

export default class ParticipationPictures extends Component {

    static propTypes = {
      data: PropTypes.shape({
        userProfilePreviewUrls: PropTypes.arrayOf(PropTypes.string)
      })
    };

  render() {
    const {
      data: {
        userProfilePreviewUrls
      }
    } = this.props;

    const images = userProfilePreviewUrls.map(url =>
      <Image
        key={url}
        style={styles.profileImg}
        source={{uri: url}} />
    );

    return (
      <View style={styles.profilesView}>
        {images}
      </View>
    );
  }
}
