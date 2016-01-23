/**
 * Created by bruceli on 24-11-14.
 */
"use strict";

import React, {
  Image,
  Text,
  View,
  Dimensions,
  Component,
  StyleSheet,
  PropTypes
} from "react-native";

import { createIconSetFromFontello } from "react-native-vector-icons";

import fontelloConfig from "../../../../assets/fontello/config.json";
const CustomIcon = createIconSetFromFontello(fontelloConfig);

const BIZ_IMAGE_WIDTH_RATIO = 0.57;
const BIZ_IMAGE_HEIGHT_RATIO = 0.33;
const BIZ_INFO_WIDTH_RATIO = 0.417;
const BIZ_INFO_WIDTH_OFFSET = 27;
const CAR_ICON_MARGIN_RATIO = 0.2;
const CAR_ICON_MARGIN_OFFSET = 60;
const PERSON_ICON_SIZE = 13;
const CAR_ICON_SIZE = 14;

const DEVICE_WIDTH = Dimensions.get("window").width;

const styles = StyleSheet.create({
  row: {
    marginLeft: 10,
    marginRight: 10,
    marginTop: 6,
    flexDirection: "row",
    justifyContent: "flex-start",
    padding: 0,
    backgroundColor: "#F5F5F5"
  },
  coverImage: {
    width: DEVICE_WIDTH * BIZ_IMAGE_WIDTH_RATIO,
    height: DEVICE_WIDTH * BIZ_IMAGE_HEIGHT_RATIO,
    marginLeft: 7,
    marginTop: 10,
    marginBottom: 10
  },
  bizInfo: {
    marginRight: 10,
    width: DEVICE_WIDTH * BIZ_INFO_WIDTH_RATIO - BIZ_INFO_WIDTH_OFFSET,
    flexDirection: "column"
  },
  text: {
    marginLeft: 12,
    marginRight: 20,
    marginTop: 16,
    fontSize: 18,
    fontWeight: "bold",
    height: 20
  },
  cityText: {
    marginLeft: 12,
    marginRight: 20,
    marginTop: 6,
    fontSize: 12
  },
  personIcon: {
    marginLeft: 12,
    marginTop: 40,
    color: "#f5a623"
  },
  carIcon: {
    marginLeft: DEVICE_WIDTH * CAR_ICON_MARGIN_RATIO - CAR_ICON_MARGIN_OFFSET,
    marginTop: 40,
    color: "#f5a623"
  },
  personText: {
    marginLeft: 2,
    marginTop: 40,
    fontSize: 11,
    color: "#b4b4b4"
  },
  etaText: {
    marginLeft: 2,
    marginRight: 20,
    marginTop: 40,
    fontSize: 11,
    color: "#b4b4b4"
  }
});

export default class BusinessInfoView extends Component {

  // static propTypes = {
  //   data: PropTypes.shape({
  //     coverImageUrl: PropTypes.string.isRequired,
  //     businessName: PropTypes.string.isRequired,
  //     location: PropTypes.string.isRequired,
  //     eta: PropTypes.string.isRequired
  //   }).isRequired
  // };

  constructor(props) {
    super(props);
  }

  render() {

    const {
      data: {
        coverImageUrl,
        businessName,
        location,
        eta
      }
    } = this.props;

    return (
        <View style={styles.row}>
          <Image style={styles.coverImage} source={{uri: coverImageUrl}} />
          <View style={styles.bizInfo}>
            <Text style={styles.text} numberOfLines={1}>
              {businessName}
            </Text>
            <Text style={styles.cityText}>
              {location}
            </Text>
            <View style={{ flexDirection: "row" }}>
              <Text style={styles.personText}>{'$40'}</Text>
              <Text style={styles.etaText}>{eta}</Text>
            </View>
          </View>
        </View>
    );
  }
}


    // <View style={styles.row}>
    //   <Image style={styles.bizImage} source={this.props.bizImage} />
    //   <View style={styles.bizInfo}>
    //     <Text style={styles.text} numberOfLines={1}>
    //       {'小肥羊'}
    //     </Text>
    //     <Text style={styles.cityText}>
    //       {'Richmond'}
    //     </Text>
    //     <View style={{ flexDirection: "row" }}>
    //       <CustomIcon name="person" style={styles.personIcon}
    //         size={PERSON_ICON_SIZE}/>
    //       <Text style={styles.personText}>{'$40'}</Text>
    //       <CustomIcon name="car" style={styles.carIcon}
    //         size={CAR_ICON_SIZE}/>
    //       <Text style={styles.distanceText}>{'10分钟'}</Text>
    //     </View>
    //   </View>
    // </View>
