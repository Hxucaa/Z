"use strict";

/*****************************
*    External Dependencies   *
******************************/

import React, {
  View,
  Component,
  StyleSheet,
  PropTypes
} from "react-native";

/*****************************
*    Internal Dependencies   *
******************************/

import BusinessInfoView from "./BusinessInfo.component";
import Participation from "./Participation.component";

/*****************************
*          Constants         *
******************************/

/*****************************
*            Code            *
******************************/
const styles = StyleSheet.create({
  cellContainer: {
    flex: 1,
    backgroundColor: "#b4b4b4"
  },
  separator: {
    marginLeft: 10,
    marginRight: 10,
    height: 1,
    backgroundColor: "#CCCCCC"
  }
});

export default class FeaturedListTableCell extends Component {

  static propTypes = {
    businessName: PropTypes.string,
    location: PropTypes.string,
    coverImageUrl: PropTypes.string,
    eta: PropTypes.string,
    averagePrice: PropTypes.string,
    treatCount: PropTypes.number,
    toGoCount: PropTypes.number
  };

  constructor(props) {
    super(props);
  }

  render() {
    const {
      coverImageUrl,
      businessName,
      location,
      eta,
      averagePrice,
      treatCount,
      toGoCount
    } = this.props;

    const userProfilePreviewUrls = [
      "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSPT62iHY6STbcLEa10W86GDsIKDUA5xMZLoI798GhRWJlrwZ35kigDwys",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQffCssqBWaFgeDQuCfemzvLDy_qEMQsjpLxiyNp8ChhLlhgdJR",
      "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTilNVI9cj4MRxzGpbMv3OJcbJUIEzrpuT8paEqLmusLZtiahdJ"
    ]

    return (

      <View style={styles.cellContainer}>
        <BusinessInfoView
          data={{
            businessName,
            location,
            coverImageUrl,
            eta,
            averagePrice
          }} />
        <View style={styles.separator} />
        <Participation
          data={{
            treatCount,
            toGoCount,
            userProfilePreviewUrls
          }} />
      </View>
    );
  }
}
