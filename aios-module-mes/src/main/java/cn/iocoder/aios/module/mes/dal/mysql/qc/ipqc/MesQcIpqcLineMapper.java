package cn.iocoder.aios.module.mes.dal.mysql.qc.ipqc;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.mes.controller.admin.qc.ipqc.vo.line.MesQcIpqcLinePageReqVO;
import cn.iocoder.aios.module.mes.dal.dataobject.qc.ipqc.MesQcIpqcLineDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * MES 过程检验单行 Mapper
 *
 * @author 芋道源码
 */
@Mapper
public interface MesQcIpqcLineMapper extends BaseMapperX<MesQcIpqcLineDO> {

    default PageResult<MesQcIpqcLineDO> selectPage(MesQcIpqcLinePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<MesQcIpqcLineDO>()
                .eqIfPresent(MesQcIpqcLineDO::getIpqcId, reqVO.getIpqcId())
                .orderByAsc(MesQcIpqcLineDO::getId));
    }

    default List<MesQcIpqcLineDO> selectListByIpqcId(Long ipqcId) {
        return selectList(MesQcIpqcLineDO::getIpqcId, ipqcId);
    }

    default void deleteByIpqcId(Long ipqcId) {
        delete(new LambdaQueryWrapperX<MesQcIpqcLineDO>()
                .eq(MesQcIpqcLineDO::getIpqcId, ipqcId));
    }

}
