/**
 * Created by bruceli on 24-11-14.
 */
"use strict";

/*****************************
*    External Dependencies   *
******************************/

import React, {
  Image,
  Text,
  View,
  Dimensions,
  Component,
  StyleSheet,
  PropTypes
} from "react-native";

/*****************************
*    Internal Dependencies   *
******************************/

import CustomIcon from "../../../../assets/lai-icons";

/*****************************
*          Constants         *
******************************/

const BIZ_IMAGE_WIDTH_RATIO = 0.57;
const BIZ_IMAGE_HEIGHT_RATIO = 0.33;
const BIZ_INFO_WIDTH_RATIO = 0.417;
const BIZ_INFO_WIDTH_OFFSET = 27;
const CAR_ICON_MARGIN_RATIO = 0.2;
const CAR_ICON_MARGIN_OFFSET = 60;
const PERSON_ICON_SIZE = 13;
const CAR_ICON_SIZE = 14;

const DEVICE_WIDTH = Dimensions.get("window").width;

/*****************************
*            Code            *
******************************/
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
  averagePriceText: {
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

  static propTypes = {
    data: PropTypes.shape({
      coverImageUrl: PropTypes.string,
      businessName: PropTypes.string,
      location: PropTypes.string,
      eta: PropTypes.string,
      averagePrice: PropTypes.string
    })
  };

  constructor(props) {
    super(props);
  }

  render() {

    const {
      data: {
        coverImageUrl,
        businessName,
        location,
        eta,
        averagePrice
      }
    } = this.props;

    const averagePriceIcon = averagePrice ?
      <CustomIcon
        name="person"
        style={styles.personIcon}
        size={PERSON_ICON_SIZE}/> :
      null

    const averagePriceText = averagePrice ?
      <Text style={styles.averagePriceText}>{averagePrice}</Text> : null

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
              {averagePriceIcon}
              {averagePriceText}
              <CustomIcon
                name="car"
                style={styles.carIcon}
                size={CAR_ICON_SIZE}/>
              <Text style={styles.etaText}>{eta}</Text>
            </View>
          </View>
        </View>
    );
  }
}
